class Oui < Formula
  desc "MAC Address CLI Toolkit"
  homepage "https://oui.is/"
  url "https://github.com/thatmattlove/oui/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "b3cb775c8ea6bf48b3b2bebcae7bb6c072620f11cdcf1b1092bae8fa15989e82"
  license "BSD-3-Clause-Clear"
  head "https://github.com/thatmattlove/oui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bc187889b787d025018c8b4cd46eaf3ecdccecc921edbc22b8b9a3cb107705d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37da5916eb4bb261e347e9b3075c3aa1a699b2ebeb163a147870fca6951e84a0"
    sha256 cellar: :any_skip_relocation, ventura:       "fbfb0a1e53cc7faa2cc3d28c64cd68bd88d848fabd95a38cbd36ee4aa9ae6051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ef3cbac92db804e53b88455d462236ff891d83ce548f6322317e57d8070f3c1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oui --version")
    output = shell_output("#{bin}/oui convert F4:BD:9E:01:23:45")
    assert_match "{244,189,158,1,35,69}", output
  end
end
