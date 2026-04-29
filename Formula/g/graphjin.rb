class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.10.tar.gz"
  sha256 "c6f7e07e3a806a4b29c949209fb224b826519e0e765a9efcaa361dc18f60f3c0"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "540c4eac8d25d51036ed59e7661ab4a9808c09b27a6a59e70c743166cf74f92e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f06a996080a9725e0abdd39f547eaa04091e05d20f72e73dc7d6c4a8ed6f469"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d8bbee4e04ef83d625bb5463ff815c539ee646734479374cb9a40b9e8ba46ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51f5a34365308fef7c4bf68e6621172ee9f4a2bdbaf47d3febf315cbc30342f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2a897025a347bb92797c1a6e7adb4602e562c945ae0aac52cef6fcef6a8b333"
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
