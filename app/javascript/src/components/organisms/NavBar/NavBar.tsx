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
} from '@mui/material'
// @ts-ignore
import logo from '../../logo2.png'

const pages = ['Directory', 'Pathfinder', 'Admin']
const settings = ['Profile', 'Account', 'Dashboard', 'Logout']

function NavBar() {

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
    <AppBar position="static" sx={{ boxShadow: 'none' }} >
      <Container >
        <Toolbar sx={{ justifyContent: 'space-around', width: '100%' }}>
          <Button href="/" sx={{
            textTransform: 'none',
            padding: 0,
            textAlign: 'left',
          }}>
            <img
              src={logo}
              alt="PharmDs in IT Logo"
              style={{ width: 50, height: 50, marginRight: 10, borderRadius: "4px" }}
            />
            <Typography variant="title" component="div" sx={{ color: 'primary.contrastText' }}>
              PharmDs in IT
            </Typography>
          </Button>
          <Box sx={{ flexGrow: 1, display: { xs: 'none', md: 'flex' }, justifyContent: 'center' }}>
            {pages.map((page) => (
              <Button
                key={page}
                onClick={handleCloseNavMenu}
                href={`/${page.toLowerCase()}`}
                sx={{ my: 2, color: 'primary.contrastText', display: 'block', letterSpacing: '0.05em' }}
              >
                {page}
              </Button>
            ))}
          </Box>

          <Box sx={{ flexGrow: 0, marginRight: 5 }}>
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
