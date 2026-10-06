class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "0a0c8b8b0e5d7c99626e1609affd4d3a9bfbe0af5452a379f0baa4502fa5b4e3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "802085b2c1dbdb729cacac013b762cf00f1276561f9c4ef30e57823d2402d24d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8bdfe12347b4c448284e576ddf782fa1de5c4295200f9835577bb532b600a9ea"
    sha256 cellar: :any,                 arm64_linux:   "68554de905d1746d6178fdd641918806e1ddebd8af5610692e3479322fd6c1ef"
    sha256 cellar: :any,                 x86_64_linux:  "4d83fa1df0fbe44ee643d6acbc103bb88e581fcfd4886868866cc262aa285abe"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rgx", "--completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rgx --version")

    assert_equal "42\n99\n", shell_output("#{bin}/rgx -p -t 'hello 42 world 99' '\\d+'")
    assert_equal "3\n", shell_output("#{bin}/rgx -p -c -t 'a1 b2 c3' '\\d+'")
  end
end
