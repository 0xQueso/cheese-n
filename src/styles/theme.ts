import { extendTheme, ThemeConfig } from "@chakra-ui/react";

const config: ThemeConfig = {
  initialColorMode: "dark",
  useSystemColorMode: false,
}

const theme = extendTheme({
  config,
  fonts: {
    heading: "Source Serif Pro",
    body: "Roboto"
  },
  styles: {
    global: {
      body: {
        bg: "#F96A53",
        color: "white",
      },
    },
  },
})
export default theme