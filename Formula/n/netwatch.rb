class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "75f85ad63f0e49c2626347977569dedafa5aa0953d2afd6f077ed675486439e2"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c5051a7df15b5b94d8b72a2a9e8b8e10e253be3255e5638abe698ae14efff7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f812829501e5a0804eacdfce829a386d3c7468e8d85f23a2ccc9ba66a17fe260"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8747a950c6ffd67e9c51aeab11631fbbe3bd5aaef3e11d374e5f95d3555e27f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1de343dcc026cf96279030120eb0393c4cc1cd9a349faa7edb31ef24c6f6f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c4ffcddc216fffe82fe6543c7baaaa56bccd9015c98cc1f11cc0b986a670e54"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netwatch", shell_output("#{bin}/netwatch --help 2>&1")
  end
end
