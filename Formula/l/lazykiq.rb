class Lazykiq < Formula
  desc "Rich terminal UI for Sidekiq"
  homepage "https://kpumuk.github.io/lazykiq/"
  url "https://github.com/kpumuk/lazykiq/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "460b9bdf6e89a518e92d6854ba9d58024aa61f77bb2ac72cf69912013abab923"
  license "MIT"
  head "https://github.com/kpumuk/lazykiq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7c8e53c6ea4c4c489447284547e8891c888b510b7f2618717275a4566b47013"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7c8e53c6ea4c4c489447284547e8891c888b510b7f2618717275a4566b47013"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7c8e53c6ea4c4c489447284547e8891c888b510b7f2618717275a4566b47013"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "452c57858503fd7ab2248acead20a1db4149ca71f098847363ace53afa7e4380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "246c8d97d9bfc8b7d4e348c5752fe3228d163bfbb3da7aa26269a2f44f2690d8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.BuiltBy=Homebrew
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/lazykiq"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazykiq --version")
    output = shell_output("#{bin}/lazykiq --redis not-a-url 2>&1", 1)
    assert_match "parse redis url", output
  end
end
