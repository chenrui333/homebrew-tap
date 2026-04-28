class Vgo < Formula
  desc "Project scaffolder for Go, written in Go"
  homepage "https://github.com/vg006/vgo"
  url "https://github.com/vg006/vgo/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3a2fee499c91225f2abe1acdb8a640560cda6f4364f4b1aff04756d8ada6282d"
  license "MIT"
  head "https://github.com/vg006/vgo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79f13327c83b0c5679af7b83a975577167a4cbbde85229dbb0101af9e45e19d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48c874bc007f1640a11e4bdb59606868ad7b05b627b66e853921b444a924f60a"
    sha256 cellar: :any_skip_relocation, ventura:       "6d35f566b820b68b28e20aeb5d24d9a6b58d035ed88895aeba30147b3041ead3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "241b1f62683ce7af6aa27c37f35b82c101abeef753b8c1fe76bf0f9e2e79cca1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vgo", "completion")
  end

  test do
    expected = if OS.mac?
      "Failed to build the vgo tool"
    else
      "┃ ✔ Built vgo\n┃ ✔ Installed vgo"
    end
    assert_match expected, shell_output("#{bin}/vgo build 2>&1")
  end
end
