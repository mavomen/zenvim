-- ~/.config/zenvim/lua/zen/core.lua

local M = {}

-- Basic options, minimal but sane
vim.g.mapleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.backup = false
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true
opt.signcolumn = "yes"

opt.updatetime = 250
opt.timeoutlen = 400

opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
opt.smartindent = true

return M
