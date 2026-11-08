class Comhad < Formula
  desc "Ranger-style terminal browser for S3-compatible storage"
  homepage "https://github.com/Eoin-McMahon/comhad"
  url "https://github.com/Eoin-McMahon/comhad/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f7e986cc14c5386eebfd043909f951578893693e017bf4951db37fd26e3b8c8e"
  license "MIT"
  head "https://github.com/Eoin-McMahon/comhad.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2c384a8f3549b73e9ad50c891ed186f1d3f53cf4b6062c2230997503aebd7bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b53647356eeca979a463c58ea0adb06be13cb9cc779df0b6d5cf2fa64de3be3"
    sha256 cellar: :any,                 arm64_linux:   "5b074c515b6ddc5603498286720adc30138223bf1d4b935604bb64df15f0de0f"
    sha256 cellar: :any,                 x86_64_linux:  "48abd8f2b4145015885732e7e86b4d4e8cc9496c80665427dae3d533f40a4fee"
  end

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
