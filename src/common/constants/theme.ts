import type { ConfigThemes } from "@heroui/react";

// 使用相对路径而非 @shared 别名：本文件被 src/hero.ts 引用，
// 后者作为 Tailwind v4 PostCSS plugin 由 @tailwindcss/node 加载，绕过 rsbuild alias
import { DARK_BACKGROUND_COLOR, LIGHT_BACKGROUND_COLOR } from "../../../shared/constants/theme";

export const Themes: ConfigThemes = {
  dark: {
    extend: "dark",
    colors: {
      background: DARK_BACKGROUND_COLOR,
      primary: "#1ed760",
    },
  },
  light: {
    extend: "light",
    colors: {
      background: LIGHT_BACKGROUND_COLOR,
      primary: "#1ed760",
    },
  },
};
