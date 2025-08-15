class Crush < Formula
  desc "Glamorous AI coding agent for your favorite terminal"
  homepage "https://github.com/charmbracelet/crush"
  url "https://github.com/charmbracelet/crush/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "a84fa00092bf9253539713e3c50451faa44240b8aa151e846dcb1aab87f1bcd3"
  # license "FSL-1.1-MIT"
  head "https://github.com/charmbracelet/crush.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15b44433344eb8a1ad3e3c9efcdf856182ec86268dcf9ad9e849226c5a8c44eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8459ead3972e80c74a6ace49fcef35205a80d3d510942e882bfbc7ebc5d6b11f"
    sha256 cellar: :any_skip_relocation, ventura:       "6419bc2a1a3f7fa7fea6bf7ef85a89e2d49dcfcad9173cdd702085f13544b03d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5e7334cade92c4345b7cfb9c00857cad8b4f865785789b991fcf06367779dd4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/charmbracelet/crush/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"crush", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crush --version")

    output = shell_output("#{bin}/crush run 'Explain the use of context in Go' 2>&1", 1)
    assert_match "no providers configured", output
  end
end
