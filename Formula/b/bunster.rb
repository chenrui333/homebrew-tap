class Bunster < Formula
  desc "Compile shell scripts to static binaries"
  homepage "https://bunster.netlify.app/"
  url "https://github.com/yassinebenaid/bunster/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "bab301b4365b0937537154afca867ec989cfe3f2d2233fabfbfa245882abaa1e"
  license "BSD-3-Clause"
  head "https://github.com/yassinebenaid/bunster.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51d508a75d0a9da15a212c1bcad2d80d0f593c30395b3cc29ee7f0956df5ccc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4fb83ac844d8253058517c855700cd67774c027588ce32cf5f925d097a7e561"
    sha256 cellar: :any_skip_relocation, ventura:       "623564ada6731ff8eed8b78778ee485d2aa3744da4127038acb87bc66c1d38d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99247861b891bc1bde0cc6236358bfb75863a601a429a2dd28f56d414522f55f"
  end

  depends_on "go"

  def install
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
