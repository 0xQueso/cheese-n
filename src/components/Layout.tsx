import { Box, Flex, FlexProps, Text } from "@chakra-ui/react"
import Link from "next/link"
import React from "react"
import { useWallet } from "../hooks/useWallet"
import { ConnectWalletButton } from "./ConnectWalletButton"

export type LayoutProps = {
  requireWallet?: boolean
  containerProps?: Partial<FlexProps>
  hideLogo?: boolean
}

const containerPadding = 8

const Layout: React.FC<LayoutProps> = ({ children, containerProps, requireWallet = false, hideLogo = false }) => {
  const { isConnected } = useWallet()
  return (
    <Box minH={"100vh"}>
      <Flex flexDir="column" minH="100vh">
        <Flex p={containerPadding} zIndex={1} alignItems="center">
          <Link href="/" passHref>
            <Text fontFamily="heading" fontSize="24px" cursor="pointer" color="#EEEE9B" _hover={{ color: "whiteAlpha.800" }} hidden={hideLogo}>
              cheese`<span style={{ color: "#fff"}}>n</span>
            </Text>
          </Link>
          <Flex justifyContent="flex-end" flex={1}>
            <ConnectWalletButton/>
          </Flex>
        </Flex>
        <Flex
          flexDirection="column"
          alignItems="center"
          flex={1}
          p={containerPadding}
          {...containerProps}
        >
          {requireWallet && !isConnected ? (
            <Box textAlign="center" my={8} width="full">
              <Text marginTop={16} marginBottom={8}>
                Connect your wallet to continue
              </Text>
              <ConnectWalletButton/>
            </Box>
          ) : children}
        </Flex>
      </Flex>
    </Box>
  )
}

export default Layout
