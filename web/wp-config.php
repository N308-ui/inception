<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * Localized language
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wpuser' );

/** Database password */
define( 'DB_PASSWORD', 'password' );

/** Database hostname */
define( 'DB_HOST', 'mariadb' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',          '!>5O=HB2nl9)-&jz<802yX|9t5^GEIJ{Ql!(R_h_ryL`s*uvvQ)VlsB|>,x!>s$1' );
define( 'SECURE_AUTH_KEY',   'z=fC[zz$Vo2N,u/lxQGLv(:J-uv9qHff? sRNAV@-_+AgTw]pRJLJ;cSZq=:9YpP' );
define( 'LOGGED_IN_KEY',     'l4yxa]BLjqGNV5-}E<+F-HWSM2Cb{!gPZJB+1g;[e~lZVd]fJtKa~?y2Qkb7hTJ`' );
define( 'NONCE_KEY',         '7hhW#RmOCG@3-Y+P]di}0yAq)_SmQsT$W84RbXjh>JT&ZtcwEqkhZvz-[gvH{D&%' );
define( 'AUTH_SALT',         'MIrdp!g?havvt==g4n7&Za.6d[Y1dF)L4Fm8A!*S)tV:+C-]qsj.i-Nlb2%ZKCOX' );
define( 'SECURE_AUTH_SALT',  '<uY7*z/[|O-zHSN^BSWCF{}8myEL`o8<=hGIfQPs3M97y2M)`%L0,kpm&WS0B,-p' );
define( 'LOGGED_IN_SALT',    '0J?`DsA{LKs+;vJ^^CF7%X;hy5kwP~!f>qpS;WS)I+Woq8zN-$`vl3ZrU@gBikMS' );
define( 'NONCE_SALT',        'rfqw)/RVd)W#zh|1[?Zdr7m%l<m1lb6`61c^K`8JtQp[qA06u3j6sRrc-C-fCjo ' );
define( 'WP_CACHE_KEY_SALT', 'FC7i@KfkI@|wR{XH*%+M!({<H`N.!S@G+,;Rq@*6Gh6n$|Y?rAT#v!Ul(b86!2F7' );


/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';


/* Add any custom values between this line and the "stop editing" line. */



/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
if ( ! defined( 'WP_DEBUG' ) ) {
	define( 'WP_DEBUG', false );
}

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
