class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.27.tar.gz"
  sha256 "971c7709e8f1392a8377b856346e3cf5f2e1b0c316c28263bf87aed1cc8adde0"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae7c5946b06740c0acbb63e204567f2a4f90b40e2bd3a8869e4f4993de065bd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aef44b4af27e2f46c6719729b3d6d1492194d47c1a531213d85ce40dd108cc19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "969e3441dae42e5097e3db0615fefac41b7c29d2f7dfbec70be711bbf80431bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c1d805961117adbb6194e57279889915c457a2d769795d91d371fd3eab73c24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ed242ec5c36f89c27b614362f576ab5cd808334a7f06ae2b2ec63029952fc0b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
