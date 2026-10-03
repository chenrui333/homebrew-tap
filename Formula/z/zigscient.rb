class Zigscient < Formula
  desc "Zig Language Server"
  homepage "https://github.com/llogick/zigscient"
  url "https://github.com/llogick/zigscient/archive/refs/tags/0.17.0.tar.gz"
  sha256 "f55ef6954a2fca944baacecdf128c3820b4c950677c543e4a1a590c2ee8946a2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02333b53179a65ac3d3c9985ff370cc0c7003e55a874501c538de6036a2515e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21f3fdaa7c4b786f1d5456f4a45d6acb0b522b179ba83089e7bfd58bccb88d0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7acaed640800a78734191adcef918b1418a22f0ec1418d8e8f1a599a30d8dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d0c0553f6d5140c45ff13a496f595b48d8038bdfcba7a8470bb21548b76512c"
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
