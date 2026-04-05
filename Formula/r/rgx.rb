class Rgx < Formula
  desc "Terminal regex tester with real-time matching and multi-engine support"
  homepage "https://github.com/brevity1swos/rgx"
  url "https://github.com/brevity1swos/rgx/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "4768e940a822fe44754e593b0b92f835d7728317226e9ba231cd0672927fc87e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/brevity1swos/rgx.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2182d7f85f1eb6add941a2106bef9c29a45d2640432fe0f377153c5fd671958"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4b223de1ecc90119ee60eefd7aa656e57e4d71bb802b021bfde174db27a37f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41ad1cbb1e67abd1b2570a08024e9f7e63baf5d0d5d4540aca12524a32b2dd1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47f88d75c23521c18587b4e4a25f5e0c732b4097a7c418e0e28e1f9d0e655307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0bcbf484c1556a9d09edaaca2e6fc5ee98f98fe4d21b96aea40bf5995083bcc"
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
