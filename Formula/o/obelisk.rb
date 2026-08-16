class Obelisk < Formula
  desc "Durable and deterministic workflow engine"
  homepage "https://github.com/obeli-sk/obelisk"
  url "https://github.com/obeli-sk/obelisk/archive/refs/tags/v0.41.2.tar.gz"
  sha256 "55baef727344cad8b36c8bcb151432e4a9cadef54f9787e3d5e1efb62522db56"
  license "AGPL-3.0-only"
  head "https://github.com/obeli-sk/obelisk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "81e0ed2660b0a24fa3ea724a96c14c61b8303f7892c7429b3435c1908b4dc5f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daf08e299145d1ca31e92b0d28ba03156f62e54afb35993fdc820a2a5141927b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a70cb48631ffbff11d75766fd459e76018e0c54063fadc08eaa6bdd1af4d87be"
    sha256 cellar: :any,                 arm64_linux:   "135e1195e1f1d38b69378ce3cfae25cc3ee321e686e5480c5dbed88542374ee8"
    sha256 cellar: :any,                 x86_64_linux:  "3d11cc228b36935be4f38ca40cc57e4eeb404ede11b848650b9d7ab696e09cfc"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/obelisk --version")
    output = shell_output("#{bin}/obelisk --not-a-real-option 2>&1", 2)
    assert_match "not-a-real-option", output
  end
end
