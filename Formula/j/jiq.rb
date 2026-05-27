class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.28.0.tar.gz"
  sha256 "a70c39c8f49ce3495ef49a4fb324f114a49b28aa11680a9c467b9f5d2c338972"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c77bad86d4b94f7860855c329b8dfb3a8b9198fe386c017445538835061c7644"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af31a45683ba41e3a63fea40539d2c4e4302b21daa19cf77dc83318b11b63790"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e5f9b751481081e8e494d3043c32f38efeb894fb1662c8fa8f80edaf65b45f80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbf94496232134d5b43b9b0d47cde78b09134d16a40af00cabd10d267f485a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8183b0c6bdc4241a7261948d805558fb252529555061d5411e200dadf717bb73"
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
