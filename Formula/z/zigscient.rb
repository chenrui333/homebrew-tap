class Zigscient < Formula
  desc "Zig Language Server"
  homepage "https://github.com/llogick/zigscient"
  url "https://github.com/llogick/zigscient/archive/refs/tags/0.17.0.tar.gz"
  sha256 "f55ef6954a2fca944baacecdf128c3820b4c950677c543e4a1a590c2ee8946a2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e66e4efcd7eae5ab3dbcd7f7f867aa24211654e4fc482855a13e0cf0d909b01d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1575e6c252d4fc087ee94bf432362d8598163ab9492fdd48412e548e6caee7c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35da05741180ea7b06c2f8f0993d685c0efb420367bb151da4cdf389c78a0fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11436a64693466dfd27564d3f92c8761fc18d1703e3b476ef620e770c11c4217"
  end

  depends_on "zig" => :build

  def install
    ENV["ZIG_LIB_DIR"] = (buildpath/"lib").to_s
    system "zig", "build", *std_zig_args(release_mode: :safe)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zigscient --version")

    output = shell_output("#{bin}/zigscient env")
    assert_match "\"settings_file_path\":", output
  end
end
