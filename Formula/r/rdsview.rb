class Rdsview < Formula
  desc "Firefox Reader View as a command-line tool"
  homepage "https://github.com/eafer/rdrview"
  url "https://github.com/eafer/rdrview/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "d0c78793f94867e9251fc3fe373026ae6ec14c02482572f5d03399891a0a83cc"
  license "Apache-2.0"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
