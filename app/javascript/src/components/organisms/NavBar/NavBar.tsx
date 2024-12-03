import React, { useState, MouseEvent } from 'react';
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
  Drawer,
  List,
  ListItem,
  ListItemButton,
  ListItemText,
} from '@mui/material';
import MenuIcon from '@mui/icons-material/Menu';
import logo from '../../logo2.png';

const pages = ['Search', 'Directory'];
const settings = ['Profile', 'Account', 'Dashboard', 'Logout'];

function NavBar() {
  const [anchorElUser, setAnchorElUser] = useState<null | HTMLElement>(null);
  const [anchorMobileEl, setAnchorMobileEl] = useState<null | HTMLElement>(
    null
  );

  const handleOpenUserMenu = (event: MouseEvent<HTMLElement>) => {
    setAnchorElUser(event.currentTarget);
  };

  const handleCloseUserMenu = () => {
    setAnchorElUser(null);
  };

  const handleOpenMobileMenu = (event: MouseEvent<HTMLElement>) => {
    setAnchorMobileEl(event.currentTarget);
  };

  const handleCloseMobileMenu = () => {
    setAnchorMobileEl(null);
  };

  console.log({ anchorElUser });
  console.log({ anchorMobileEl });

  return (
    <AppBar position="static" sx={{ boxShadow: 'none' }}>
      <Container>
        <Toolbar sx={{ justifyContent: 'space-between' }}>
          <Button
            href="/"
            sx={{
              textTransform: 'none',
              padding: 0,
              textAlign: 'left',
            }}
          >
            <img
              src={logo}
              alt="PharmDs in IT Logo"
              style={{
                width: 50,
                height: 50,
                marginRight: 10,
                borderRadius: '4px',
              }}
            />
            <Typography
              variant="title"
              component="div"
              sx={{ color: 'primary.contrastText' }}
            >
              PharmDs in IT
            </Typography>
          </Button>

          {/* Desktop Navigation */}
          <Box
            sx={{
              display: { xs: 'none', md: 'flex' },
              justifyContent: 'center',
            }}
          >
            {pages.map((page) => (
              <Button
                key={page}
                href={`/${page.toLowerCase()}`}
                sx={{
                  m: 2,
                  color: 'primary.contrastText',
                  display: 'block',
                  letterSpacing: '0.05em',
                }}
              >
                {page}
              </Button>
            ))}
          </Box>

          {/* Mobile Menu Icon */}
          <IconButton
            edge="start"
            color="inherit"
            aria-label="menu"
            onClick={handleOpenMobileMenu}
            sx={{ display: { xs: 'flex', md: 'none' } }}
          >
            <Tooltip title="Open navigation menu">
              <MenuIcon />
            </Tooltip>
          </IconButton>

          {/* Mobile Navigation Menu */}
          <Menu
            sx={{ mt: '45px' }}
            anchorEl={anchorMobileEl}
            anchorOrigin={{
              vertical: 'top',
              horizontal: 'right',
            }}
            transformOrigin={{
              vertical: 'top',
              horizontal: 'right',
            }}
            open={Boolean(anchorMobileEl)}
            onClose={handleCloseMobileMenu}
          >
            {pages.map((page) => (
              <MenuItem key={page} onClick={handleCloseMobileMenu}>
                <Button href={`/${page.toLowerCase()}`}>{page}</Button>
              </MenuItem>
            ))}
          </Menu>

          <Box>
            <Tooltip title="Open settings">
              <IconButton onClick={handleOpenUserMenu} sx={{ p: 0 }}>
                <Avatar alt="Remy Sharp" /> {/*TODO change icon  */}
              </IconButton>
            </Tooltip>
            <Menu
              sx={{ mt: '45px' }}
              id="menu-appbar"
              anchorEl={anchorElUser}
              anchorOrigin={{
                vertical: 'top',
                horizontal: 'right',
              }}
              keepMounted
              transformOrigin={{
                vertical: 'top',
                horizontal: 'right',
              }}
              open={Boolean(anchorElUser)}
              onClose={handleCloseUserMenu}
            >
              {settings.map((setting) => (
                <MenuItem key={setting} onClick={handleCloseUserMenu}>
                  <Button key={setting} href={`/${setting.toLowerCase()}`}>
                    {setting}
                  </Button>
                </MenuItem>
              ))}
            </Menu>
          </Box>
        </Toolbar>
      </Container>
    </AppBar>
  );
}
export default NavBar;
