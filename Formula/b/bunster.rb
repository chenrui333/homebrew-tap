class Bunster < Formula
  desc "Compile shell scripts to static binaries"
  homepage "https://bunster.netlify.app/"
  url "https://github.com/yassinebenaid/bunster/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "bab301b4365b0937537154afca867ec989cfe3f2d2233fabfbfa245882abaa1e"
  license "BSD-3-Clause"
  head "https://github.com/yassinebenaid/bunster.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "821a29b06508df5a2544a8aa5e68a8173ce3f10749f0f7ac29b0af64772638a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c53afaaf0e5436e28ec03fb5656437b788bb04a84ea35a5ab2e17a4d2baba61f"
    sha256 cellar: :any_skip_relocation, ventura:       "6978afeae129d6287bdd83e46ff8389df880692a8ab5f2ea42dbe576cd2e1008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea3adcae07c2e40745f6ab435ce274cf0b5fdf3abdf127d3c8dd27a3a9f1ff19"
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
