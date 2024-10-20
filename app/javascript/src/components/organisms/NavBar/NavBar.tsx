import React, { useState, MouseEvent } from 'react'
import {
  AppBar,
  Box,
  Toolbar,
  Typography,
  Container,
  IconButton,
  Menu,
  MenuItem,
  Button,
  Tooltip,
  Avatar,
  useTheme,
} from '@mui/material'


const pages = ['Search', 'Directory', 'Pathfinder', 'Admin']
const settings = ['Profile', 'Account', 'Dashboard', 'Logout']

function NavBar() {
  const theme = useTheme();
  console.log(theme.palette.primary)

  const [anchorElNav, setAnchorElNav] = useState<null | HTMLElement>(null)
  const [anchorElUser, setAnchorElUser] = useState<null | HTMLElement>(null)

  const handleOpenNavMenu = (event: MouseEvent<HTMLElement>) => {
    setAnchorElNav(event.currentTarget)
  }
  const handleOpenUserMenu = (event: MouseEvent<HTMLElement>) => {
    setAnchorElUser(event.currentTarget)
  }

  const handleCloseNavMenu = () => {
    setAnchorElNav(null)
  }

  const handleCloseUserMenu = () => {
    setAnchorElUser(null)
  }

  return (
    <AppBar position="static" sx={{ backgroundColor: 'green.main' }}
    >
      <Container
      >
        <Toolbar
        >
          <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
            PharmDs in IT
          </Typography>
          <Box sx={{ flexGrow: 1, display: { xs: 'none', md: 'flex' } }}>
            {pages.map((page) => (
              <Button
                key={page}
                onClick={handleCloseNavMenu}
                href={`/${page.toLowerCase()}`}
                sx={{ my: 2, color: 'white', display: 'block' }}
              >
                {page}
              </Button>
            ))}
          </Box>

          <Box sx={{ flexGrow: 0 }}>
            <Tooltip title="Open settings">
              <IconButton onClick={handleOpenUserMenu} sx={{ p: 0 }}>
                <Avatar alt="Remy Sharp" />{' '}
                {/*TODO change icon  */}
              </IconButton>
            </Tooltip>
            <Menu
              sx={{ mt: '45px' }}
              id="menu-appbar"
              anchorEl={anchorElUser}
              anchorOrigin={{
                vertical: 'top',
                horizontal: 'right'
              }}
              keepMounted
              transformOrigin={{
                vertical: 'top',
                horizontal: 'right'
              }}
              open={Boolean(anchorElUser)}
              onClose={handleCloseUserMenu}
            >
              {settings.map((setting) => (
                <MenuItem key={setting} onClick={handleCloseUserMenu}>
                  <Button
                    key={setting}
                    onClick={handleCloseNavMenu}
                    href={`/${setting.toLowerCase()}`}
                  >
                    {setting}
                  </Button>
                </MenuItem>
              ))}
            </Menu>
          </Box>
        </Toolbar>
      </Container>
    </AppBar>
  )
}
export default NavBar
