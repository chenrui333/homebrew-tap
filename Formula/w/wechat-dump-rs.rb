class WechatDumpRs < Formula
  desc "导出微信进程密钥并自动/离线解密数据库文件"
  homepage "https://github.com/0xlane/wechat-dump-rs"
  url "https://github.com/0xlane/wechat-dump-rs/archive/refs/tags/v1.0.31.tar.gz"
  sha256 "67ac8180d7a11ac3a4be6e15982a6daf4d68d41a43d286a45fbe24781e3815e2"
  # license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end
end
