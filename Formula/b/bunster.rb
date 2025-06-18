class Bunster < Formula
  desc "Compile shell scripts to static binaries"
  homepage "https://bunster.netlify.app/"
  url "https://github.com/yassinebenaid/bunster/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "65ae0de089da9ae7166ff608a9eedbdb42eab5abfbfab347fed58cb5466fa7e2"
  license "BSD-3-Clause"
  head "https://github.com/yassinebenaid/bunster.git", branch: "master"

  depends_on "go"

  def install
    # patch version, upstream commit, https://github.com/yassinebenaid/bunster/commit/731326f80501b85011467991f61a5728a17a86da
    inreplace "VERSION", "0.12.1", version.to_s
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/bunster"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bunster --version")

    (testpath/"test.sh").write <<~SHELL
      #!/bin/bash
      echo "Hello, World!"
    SHELL

    system bin/"bunster", "build", "test.sh", "-o", "test-binary"
    assert_path_exists testpath/"test-binary"
    assert_match "Hello, World!", shell_output("./test-binary")
  end
end
