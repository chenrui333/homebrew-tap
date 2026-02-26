class OmniCache < Formula
  desc "Sidecar for your caching needs in CI"
  homepage "https://github.com/cirruslabs/omni-cache"
  url "https://github.com/cirruslabs/omni-cache/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "adb2b16e27a632f71a69b3c8aec03ce175f796a9daf79c2e1b0ae278c4f8b767"
  license "Apache-2.0"
  head "https://github.com/cirruslabs/omni-cache.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54f47cca9cc7ebbedfd15d6ea443b51b2cd941d469ef2491457148810cc9d431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7402248acd58c4398995cf257a4f8faab56eabf924338940813ba4e50596e48c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbe865be5646715b19332b826bccc00f2d0ff429bb86f0b3e96d2faffb622016"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "175b6143ac079e3c8d38b337679f68985608217fabfc09e9d8b047ae01e6600f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d50edf628c9d7d4bc828d76c4563fa02ff410638c698eb8fb492bc354238cf3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/cirruslabs/omni-cache/internal/version.Version=#{version}
      -X github.com/cirruslabs/omni-cache/internal/version.Commit=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/omni-cache"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/omni-cache --version")

    output = shell_output("#{bin}/omni-cache sidecar 2>&1", 1)
    assert_match "missing required bucket", output
  end
end
