class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.80.9.tar.gz"
  sha256 "a8acc2912c8e0c2277e38a7b3e804076d92c08fd73d8f656d92b742b8f0f948d"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "107bf2f0825cedcbe819978a716c093b0275eff4f8dff8b89c2dc15c559a896c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "107bf2f0825cedcbe819978a716c093b0275eff4f8dff8b89c2dc15c559a896c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "107bf2f0825cedcbe819978a716c093b0275eff4f8dff8b89c2dc15c559a896c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6c7f8b7932fc826a48f9ea678ce488df4829c4d5156be823c4339d56f946d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d1f8adbdb9d242f2f9875f9a6388a3e2a5e774f130d0dd3766f17d945244f06"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end
