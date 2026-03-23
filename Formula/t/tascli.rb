class Tascli < Formula
  desc "Track tasks and records from the terminal"
  homepage "https://github.com/Aperocky/tascli"
  url "https://github.com/Aperocky/tascli/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "e7ce1b10383724bac04ca8927895693945838e8bee5c43cf89c4ab458b65fb1d"
  license "MIT"
  head "https://github.com/Aperocky/tascli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "48ef271bb0c2818bc18106e65de71805bcb6e75d3795404cb23eef62182920ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6091e0dbc11781f43a183df5edc133611159ee96203697a97eb1758ef1fc871d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08ca2e093e6ab1e7bcd94299743cb338830ffd998593642edc3ca4843db4927b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "761fceed99115d7b0717c050a22f67300737bef35abd32598773a95c13484888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05dac6c5058c39671608707a05be13ad702dd2a7b86520caa3bb715119b750da"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    task_content = "Write formula test"

    assert_match version.to_s, shell_output("#{bin}/tascli --version")

    system bin/"tascli", "task", "-c", "work", task_content, "today"

    output = shell_output("#{bin}/tascli list task -c work")
    assert_match task_content, output
    assert_match "work", output
    assert_path_exists testpath/".local/share/tascli/tascli.db"
  end
end
