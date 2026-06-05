class Lfk < Formula
  desc "Lightning fast Kubernetes navigator"
  homepage "https://github.com/janosmiko/lfk"
  url "https://github.com/janosmiko/lfk/archive/refs/tags/v0.13.7.tar.gz"
  sha256 "762967e25b4060f213ef1f8c3654e45dfdd9e97d313e054a4f60d4b3813dede6"
  license "Apache-2.0"
  head "https://github.com/janosmiko/lfk.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "368c0158a0a0a69a43515ec293f3659013fe5189ad985ef9e562283d9081b822"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "368c0158a0a0a69a43515ec293f3659013fe5189ad985ef9e562283d9081b822"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "368c0158a0a0a69a43515ec293f3659013fe5189ad985ef9e562283d9081b822"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c683fb8c7d5da3d26ee4161b0e898269fdb332cb238995d71ce7160a62969e7"
    sha256 cellar: :any,                 x86_64_linux:  "856c228345f660286a0a994d96c4c97783d5911ec88676f5bcfd12747c60b292"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/janosmiko/lfk/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"lfk", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lfk --version 2>&1")
    assert_match "#compdef lfk", shell_output("#{bin}/lfk completion zsh")
  end
end
