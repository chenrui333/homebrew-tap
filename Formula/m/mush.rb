class Mush < Formula
  desc "Build system for shell packages"
  homepage "https://github.com/javanile/mush"
  url "https://github.com/javanile/mush/archive/refs/tags/0.2.0.tar.gz"
  sha256 "131beca689a347402f8cc67d54208c93e8abd7d79207d8d964e93ebd2b37bc48"
  license "MIT"
  head "https://github.com/javanile/mush.git", branch: "main"

  depends_on "bash"

  def install
    inreplace "bin/mush",
              "#!/usr/bin/env bash",
              "#!#{Formula["bash"].opt_bin}/bash"
    inreplace "bin/mush",
              'VERSION="Mush 0.1.1 (2023-11-03)"',
              'VERSION="Mush 0.2.0"'

    bin.install "bin/mush"
  end

  test do
    system bin/"mush", "new", "demo"

    assert_match "0.2.0", shell_output("#{bin}/mush --version")
    assert_path_exists testpath/"demo/Manifest.toml"
    assert_path_exists testpath/"demo/src/main.sh"
  end
end
