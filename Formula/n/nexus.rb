class Nexus < Formula
  desc "Terminal-based HTTP client for REST and gRPC APIs"
  homepage "https://github.com/pranav-cs-1/nexus"
  url "https://github.com/pranav-cs-1/nexus/archive/0906a0fd7799058a35adaf58160d5e2027a59e83.tar.gz"
  version "0.2.1"
  sha256 "e5ca698629a915f4b988c8b91d79059c4ac7ff245ef86cbd24235bd96eedf349"
  license "MIT"
  head "https://github.com/pranav-cs-1/nexus.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    output = shell_output("#{bin}/nexus 2>&1", 1)
    if OS.mac?
      assert_match "Inappropriate ioctl for device", output
    else
      assert_match "No such device or address", output
    end
  end
end
