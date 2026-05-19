class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.22.3.tar.gz"
  sha256 "258c34b1a3945584e80e0d4c697248c4c1003fe630e674f9fa5ed9d6829c7048"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "578017f3882adc54c277f2258b355447d943d12b222de60720e6889e69b8d592"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb280a335689b89c00bba7443910c798b0b0361ff4883bcc75e87f8cdd8e5c50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af2786336b1052d4e04e3a74421d938af2c6115ca6fdf6e9e9695a931be4e95a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eaf1ca35a3685d60f967416784cfb9af47e00dfef52032e096c80a3ea3ddb826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0efb6fc9326fb629ee1f71eb1468b66c85c2b864cd58faeb75df633b88f989bd"
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
