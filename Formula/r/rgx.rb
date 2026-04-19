class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "9affcf4a715cdd884133a04bb2b5db2b7114d4179d8abe18235fc42dbc42aa6f"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ea4099b44e4fb24907099e71893429d17721c5d1141fedc0a4dbee94fd8dca0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0b0385192059d18f23524c3b0457a2969d6cc92e0485381cb68306e262a0af14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2019965da8149ae58177d33d00b3d1ed0fef42e0656b224266e72388bfd49776"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc605432c675c90ae5f4272148ea0392579532c2b83dbd1f5e23b7cc9c0ddca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ee8dcd6f68e57f0eb62b45c4d2b536059d626c1e2d54c882de96834315911380"
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
