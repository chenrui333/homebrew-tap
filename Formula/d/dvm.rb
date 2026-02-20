class Dvm < Formula
  desc "Deno Version Manager"
  homepage "https://dvm.deno.dev"
  url "https://github.com/justjavac/dvm/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "ce52f153d7d11f9cec3904b2a22b7298576a76be2f93fb026f8b780e5770d2df"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd38b1c7bc1f064095856267472166798aa867cddf60d82c5aed6d23e43b197e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "484f96e1f39844566bbcf97788cdbcd2b802b44ac4199eaa561650ec30f81355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d73ff5be88bafe6763e6b2e740e4143314fbe9b915c8f729bd7db615ea041d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e1ef5160e83890f2cea3b1e98a6d02a767f7c8abd8bdcea7d18545a167de57c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4082076f29acbcaf03cd78733ae4ae443d66b64004bf1d3e711c1660deb2504e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"dvm", "completions")
  end

  test do
    output = shell_output("#{bin}/dvm info")
    assert_match "dvm #{version}", output
    assert_match(/^deno\s+\S+$/, output.lines[1].chomp)
    assert_match "dvm root #{Dir.home}/.dvm", output

    assert_match version.to_s, shell_output("#{bin}/dvm --version")
  end
end
