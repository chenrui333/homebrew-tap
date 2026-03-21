class Rip < Formula
  desc "Fuzzy find and kill processes from the terminal"
  homepage "https://github.com/cesarferreira/rip"
  url "https://github.com/cesarferreira/rip/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "c0e57126bb07a11352bccf30e067b35cb9a3928d458789f77157ca2ae038603b"
  license "MIT"
  head "https://github.com/cesarferreira/rip.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b31e43c8193ccaae28cefc97ca3ac9423cdd3c8e69fc67ef8406e85d258b56d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "293d60a32277332ad8ca2d5e12af5f37c4b5e45d516c1773db6bebc6d1378631"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c86e8359e8eeee8570fc8dc58d6a30e67b74703397f57a14c3294f90a584bb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0511103d2f3f40799115d0c3cb3bb022b24d806384f8654d9f57abe028d446a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0b5c3c8084087a33acbec4a85927730c46253b5a2f3b71a29fc5bfe085e4b34"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rip --version")

    port = free_port
    ruby = RbConfig.ruby
    pid = spawn(
      ruby, "-e",
      "require 'socket'; server = TCPServer.new('127.0.0.1', #{port}); sleep 60"
    )
    sleep 2

    output = shell_output("#{bin}/rip --port #{port} --confirm-nuke")
    assert_match "Killed", output

    Process.wait(pid)
    assert_predicate $CHILD_STATUS, :signaled?
  end
end
