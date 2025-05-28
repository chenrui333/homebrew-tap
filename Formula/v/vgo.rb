class Vgo < Formula
  desc "Project scaffolder for Go, written in Go"
  homepage "https://github.com/vg006/vgo"
  url "https://github.com/vg006/vgo/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3a2fee499c91225f2abe1acdb8a640560cda6f4364f4b1aff04756d8ada6282d"
  license "MIT"
  head "https://github.com/vg006/vgo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dd97d329f39d19e6cce4571ba20ee83f1bad4e7c6cea8f72eb1d953a50e3bf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e643f79844b44119ef0fd885162234f97eafc6ae5b4e8ef5a98c6a9b3b414c10"
    sha256 cellar: :any_skip_relocation, ventura:       "bbfcd0daac31e1541f68fb0d6e9587c1e365b56bdd2242026f80d8ab7f23a20f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63d82f578d21f49e8f81e98db8986bb15f0c6f3623d752ab9a43b86147743e63"
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
