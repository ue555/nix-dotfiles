import type {
  ContextBuilder,
  ExtOptions,
  Plugin,
  ProtocolName,
} from "@shougo/dpp-vim/types";
import {
  BaseConfig,
  type ConfigReturn,
} from "@shougo/dpp-vim/config";
import { Protocol } from "@shougo/dpp-vim/protocol";

import type {
  Ext as TomlExt,
  Params as TomlParams,
} from "@shougo/dpp-ext-toml";
import type {
  Ext as LazyExt,
  LazyMakeStateResult,
  Params as LazyParams,
} from "@shougo/dpp-ext-lazy";

import type { Denops } from "@denops/std";

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    contextBuilder: ContextBuilder;
    basePath: string;
  }): Promise<ConfigReturn> {
    args.contextBuilder.setGlobal({
      protocols: ["git"],
    });

    const [context, options] = await args.contextBuilder.get(args.denops);
    const protocols = await args.denops.dispatcher.getProtocols() as Record<
      ProtocolName,
      Protocol
    >;

    const dotfilesDir = "~/dotfiles/vim/tomls/";

    // Load toml plugins
    const recordPlugins: Record<string, Plugin> = {};
    const ftplugins: Record<string, string> = {};
    const hooksFiles: string[] = [];

    const [tomlExt, tomlOptions, tomlParams]: [
      TomlExt | undefined,
      ExtOptions,
      TomlParams,
    ] = await args.denops.dispatcher.getExt(
      "toml",
    ) as [TomlExt | undefined, ExtOptions, TomlParams];

    if (tomlExt) {
      const action = tomlExt.actions.load;

      const tomlPromises = [
        { path: dotfilesDir + "tool.toml", lazy: false },
        { path: dotfilesDir + "dpp.toml", lazy: false },
        { path: dotfilesDir + "ddc.toml", lazy: false },
      ].map((tomlFile) =>
        action.callback({
          denops: args.denops,
          context,
          options,
          protocols,
          extOptions: tomlOptions,
          extParams: tomlParams,
          actionParams: {
            path: tomlFile.path,
            options: {
              lazy: tomlFile.lazy,
            },
          },
        })
      );

      const tomls = await Promise.all(tomlPromises);

      for (const toml of tomls) {
        for (const plugin of toml.plugins ?? []) {
          recordPlugins[plugin.name] = plugin;
        }

        if (toml.ftplugins) {
          for (const filetype of Object.keys(toml.ftplugins)) {
            if (ftplugins[filetype]) {
              ftplugins[filetype] += `\n${toml.ftplugins[filetype]}`;
            } else {
              ftplugins[filetype] = toml.ftplugins[filetype];
            }
          }
        }

        if (toml.hooks_file) {
          hooksFiles.push(toml.hooks_file);
        }
      }
    }

    const [lazyExt, lazyOptions, lazyParams]: [
      LazyExt | undefined,
      ExtOptions,
      LazyParams,
    ] = await args.denops.dispatcher.getExt(
      "lazy",
    ) as [LazyExt | undefined, ExtOptions, LazyParams];

    let lazyResult: LazyMakeStateResult | undefined = undefined;
    if (lazyExt) {
      const action = lazyExt.actions.makeState;

      lazyResult = await action.callback({
        denops: args.denops,
        context,
        options,
        protocols,
        extOptions: lazyOptions,
        extParams: lazyParams,
        actionParams: {
          plugins: Object.values(recordPlugins),
        },
      });
    }

    return {
      ftplugins,
      hooksFiles,
      plugins: lazyResult?.plugins ?? [],
      stateLines: lazyResult?.stateLines ?? [],
    };
  }
}
