class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.35.0.tar.gz"
  sha256 "3ddb12971a6a15010c8f74f5b08a7e3587967f0f81eaee2a156df5fe910475b1"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8491d89e0b233eda6e9ada142b917cc88c29c34228c8b631582eb3a3edb65042"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79d5c3a40a19b1734e6654422e197bbcff812f1a73f212eb3604ea99ef452bbd"
    sha256 cellar: :any,                 arm64_linux:   "02afcd58658d155de5c6176a18df959ae8aa7b4f9051a65d7f9601b07c9717e0"
    sha256 cellar: :any,                 x86_64_linux:  "daa560f9b7b4d6c28e645c64672767c47c8157b4fed610b05df5d7bf84e34ec3"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jiq --version")

    (testpath/"data.json").write("{}\n")
    empty_path = testpath/"empty"
    empty_path.mkpath
    output = shell_output("PATH=#{empty_path} #{bin}/jiq #{testpath}/data.json 2>&1", 1)
    assert_match "jq binary not found in PATH.", output
  end
end
