class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.22.1.tar.gz"
  sha256 "797d0b988e0231a20cb4da205ddb1f4e3b974c15613f45951fbd502d9082a418"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f36af192803e8c1de89d0cbac237e8fb0f9cc259bbab6aad9c38d731e6bb9ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f705f7f96d3912c215ffc46bcab8d95cae011d879fd69faa4bb64e6a7c32c8ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "216236dd89d5ded9cdf0a3143bcc88c03041b7a65a7a55ed0236cb8375708125"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f25028ed01a16ce013f02115e52681ef081ca1c4fa64733a5a002767c07c12a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b19e8e863ec4dcb2ecfe3663eaf84ea5293df5d52ab111f25092b166f460667"
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
