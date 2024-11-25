require.config({
    baseUrl: window.config.Require.baseUrl,
    waitSeconds: window.config.Require.waitSeconds,
    map: {
        '*': {
            'css': 'css.min'
        }
    },
    paths: {
        //-- Rotate
        Rotate: 'jquery.rotate.min',
        //-- Snap Svg
        SnapSvg: 'snap.svg-min',
        //-- Menu
        Classie: 'classie',
        Menu: 'menu',
        //-- Search
        InstantSearch: 'instantsearch.min',
        Search: 'search',
        //-- Lazy Load
        LazyLoad: 'jquery.lazyload.min',
        //-- Home Animation
        CircleMagic: 'circleMagic',
        //-- Donate
        Donate: 'donate',
        //-- ProgressBar
        ToProgress: 'ToProgress.min',
	    //-- Ribbons
        RibbonsEffect: 'RibbonsEffect',
        //-- Tocbot
        Tocbot: 'tocbot',
        //-- LeanCloud Storage
        LeanCloud: 'av-min',
        //-- Valine
        Valine: 'Valine.min',
        //-- Tools
        Tools: 'tools',
        //-- Clipboard
        Clipboard: 'clipboard.min',
        //-- FancyBox
        FancyBox: 'jquery.fancybox',
        //-- Gsap
        Gsap: 'gsap.min',
        //-- Mouse
        Mouse: 'mouse',
        //-- Velocity
        Velocity: 'velocity.min',
        VelocityUI: 'velocity.ui.min',
        //-- Base
        Base: 'base'
    },
    shim:{
        Classie: {
            deps: ['SnapSvg']
        },
        Menu: {
            deps: [
                'SnapSvg', 
                'Classie', 
                'css!' + window.config.Style.menuBubble
            ]
        },
        Search: {
            deps: [
                'InstantSearch', 
                'css!' + window.config.Style.search
            ]
        },
        Donate: {
            deps: ['css!' + window.config.Style.donate]
        },
        Valine: {
            deps: [
                'LeanCloud',
                'css!' + window.config.Style.valine
            ]
        },
        Tocbot: {
            deps: ['css!' + window.config.Style.tocbot]
        },
        Clipboard: {
            deps: ['css!' + window.config.Style.clipboard]
        },
        FancyBox: {
            deps: ['css!' + window.config.Style.fancybox]
        },
        Mouse: {
            deps: ['css!' + window.config.Style.mouse]
        },
        Base: {
            deps: [
                'Tools',
                'css!' + window.config.Style.footer, 
                'css!' + window.config.Style.iconfont // 阿里云字体图标
            ]
        }
    }
});
