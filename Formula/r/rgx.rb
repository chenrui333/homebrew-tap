class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "f2e4e24ed3a3c0f4951796ef79e47b892a20e222bd35272b1f5b9c5b1f57a611"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2cac494cb0a560786b0fa2096078d6b21ff2184e9e2dd2f1afb10744bb3cf0d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd1900bbc4eadeff681fe3ea191588e383741dc1ea35e1cec469966948357947"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ecceeb86b47150e7a663fa55e34b5aee3d836e4d17f3701d47184860f1c8243"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1c1b1fc28ddf0c8c35d47a229037d85c6c7ccee525b3e424b57e970db688ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38b5ddd32e1c9de6dae6cadcf1ec97f3eb047daefcb37bd1b119ba872595bad5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
    generate_completions_from_executable(bin/"rgx", "--completions")
  end

  test do
    assert_equal "42\n99\n", shell_output("#{bin}/rgx -p -t 'hello 42 world 99' '\\d+'")
    assert_equal "3\n", shell_output("#{bin}/rgx -p -c -t 'a1 b2 c3' '\\d+'")
  end
end
