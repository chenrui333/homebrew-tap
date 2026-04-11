class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.10.2.tar.gz"
  sha256 "64dd3e8d4845464e218f52da18ebd66ca0a2d93aa5419170da272ae8bb606502"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f74bda5701acb8d76c1f2cf6f416d92f8cfe9817fa480f9b8005d249510c892d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eac381ecf053e03cf7ddfd6c33406fc7f9b80202096e735f314db6f4bd58278e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2a091b7b3fd5b0f613731525001aad7eade0577750b1fe63138202386636fe5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "902db19428e90cbf454f9b756094c51f5a0ee774b0497480582271274e289040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ade89fa85569d1155af7e329a5c413c5a0e5c8dd98bde69fd665acd80005a3b8"
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
