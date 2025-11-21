class Await < Formula
  desc "Small binary that runs a list of commands in parallel and awaits termination"
  homepage "https://github.com/slavaGanzin/await"
  url "https://github.com/slavaGanzin/await/archive/refs/tags/2.4.0.tar.gz"
  sha256 "3abecf4f70382970476102ab4ef9601cf30564cc3a0f8385228b791f3e515960"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e62a20d6e63daff6b4c97fde87a8dc23f0b8f13a8f691e0543dc114e5997b146"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94b21a6dc5d313a7d61fdf5301bff5e596f43dc716e6f25b97c686b0c852df26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d13485cd0f3a605a7708f2744ba2dbed18edd9bf8fe57c1d6453ef127cbabed6"
    sha256 cellar: :any_skip_relocation, sequoia:       "63db4ca8f8f574a34c0c195ca92d446f201f6d9deb0c3250d09f162d5dfeec46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3962243b83472c4d1d9841ee35569460d28f5df5eee84f6539af146113424f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d49e558f848ef82c0ea88029e4938215db2e9f7d26553e4e49b99d8b7cc1a94"
  end

  def install
    system ENV.cc, "await.c", "-o", "await", "-lpthread"
    bin.install "await"

    bash_completion.install "autocompletions/await.bash" => "await"
    zsh_completion.install "autocompletions/await.zsh" => "_await"
    fish_completion.install "autocompletions/await.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/await --version")

    (testpath/"test_script.sh").write <<~SHELL
      #!/bin/bash
      echo "Test script running" > "#{testpath}/output.txt"
    SHELL
    chmod 0755, testpath/"test_script.sh"

    system bin/"await", "./test_script.sh"
    assert_path_exists testpath/"output.txt"
    assert_match "Test script running", (testpath/"output.txt").read
  end
end
