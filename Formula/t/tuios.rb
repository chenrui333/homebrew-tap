class Tuios < Formula
  desc "Terminal UI OS (Terminal Multiplexer)"
  homepage "https://github.com/Gaurav-Gosain/tuios"
  url "https://github.com/Gaurav-Gosain/tuios/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "7bafdbec5c89458ca2121235b642063504565276c00bdd2ff2dad15056722509"
  license "MIT"
  head "https://github.com/Gaurav-Gosain/tuios.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f8f0678847675ca50d40f88765f7094d5cfaef695d96b8e7b22573008265d42d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2936a4ab2acbbd1de6be8aa8a9a667ef393afdc0ea003a681e59ab68864cf0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "634947415bea0b18b8c290de78a3e44e4ec78f9267a4b2f63b526964b82fa888"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "164037673f8a62695d2583aaf0f77295c2002b14ee0e4da1ae848a29e7c49828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d32390de66717e15188043e2efdd321d26ee0272bd1b8b30e6f65ae6cfbc56d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/tuios"

    generate_completions_from_executable(bin/"tuios", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tuios --version")

    assert_match "git_hub_dark", shell_output("#{bin}/tuios --list-themes")
  end
end
