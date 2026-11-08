class Comhad < Formula
  desc "Ranger-style terminal browser for S3-compatible storage"
  homepage "https://github.com/Eoin-McMahon/comhad"
  url "https://github.com/Eoin-McMahon/comhad/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f7e986cc14c5386eebfd043909f951578893693e017bf4951db37fd26e3b8c8e"
  license "MIT"
  head "https://github.com/Eoin-McMahon/comhad.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    (testpath/".comhad/config.toml").write("[invalid")
    output = shell_output("#{bin}/comhad 2>&1", 1)
    assert_match "failed to parse", output
    assert_match "config.toml", output
  end
end
