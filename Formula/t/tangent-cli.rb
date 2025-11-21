class TangentCli < Formula
  desc "Stream processing with real languages, not DSLs"
  homepage "https://docs.telophasehq.com/cli/overview"
  url "https://github.com/telophasehq/tangent/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "b24b120a7cda2f989344d932f729897a4ef08600fc39f3ddc052746b0f80ff5a"
  license "MPL-2.0"
  head "https://github.com/telophasehq/tangent.git", branch: "main"

  depends_on "cmake" => :build # for rdkafka-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tangent --version")

    system bin/"tangent", "plugin", "scaffold", "--name", "brewtest", "--lang", "go"
    assert_path_exists testpath/"brewtest/go.mod"
  end
end
