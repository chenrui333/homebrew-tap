class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.28.0.tar.gz"
  sha256 "a70c39c8f49ce3495ef49a4fb324f114a49b28aa11680a9c467b9f5d2c338972"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12beb7232bd6f9afa7625e257d309ee857e32ed874416942fa1a4a07a3031e88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "680859ee5a47f9961f90b91013ccfd36e890def10437a534bb16771446b26fb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "672c42c71b8172633ed278afc5227fc8707e0a661f3d7c036d92b492231b5d98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fe5740f831483e81907b4aafe5eb7e1e03c9577ed6217788ed000a1c97e61e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a311d2a2562e5548b2158fda676e47893added2c6afa992bdbdca8266dbb4bb7"
  end

  depends_on "rust" => :build

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
