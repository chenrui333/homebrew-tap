class Jiq < Formula
  desc "Interactive JSON query tool with real-time output and AI assistance"
  homepage "https://github.com/bellicose100xp/jiq"
  url "https://github.com/bellicose100xp/jiq/archive/refs/tags/v3.23.4.tar.gz"
  sha256 "ee7d1f6b6c3a3f01d268d39129357d6502a22fb48beb2f9666b06d9b0fead935"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df9d4639456e0014ecc9cb30a5194b1dceddda7aeaa315849985542b791fa9ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "963a820e940fa450a17a2e0ac1e5e75f947230af4ac1bca4fa550315c69bc157"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15652166c9fe35c34191064af99cf345b0ed0887a8902d616aa8a006d9d824f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c98f88629dcd8b2f6770a4a7db93474c6239d4a917acf272f4fa7d78c548eccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32ee0f841b98ac2dc4949bf5a6e3bba60103efb3d9f5706a8036195df4e0cf47"
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
