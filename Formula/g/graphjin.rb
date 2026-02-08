class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "26b5b8e6402ba8313ae5175347aac9bf58dd4e0d9eee9561b5c24385ea6203f5"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4f808f01e6ac7c65e684dbbb1f26821975a24ce5e33ec84396ac6b686ce1c05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81b01ea2278e5b632fdf3c5a1ea00c794382e3e7b1179409ea22b54fec3b0c4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4642d15f9769cc5c9d2f328a009c8de56caab46c8f8f2dfa9caea09634d82977"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "576ee688c1536cf1b61f137a3727eaada2a79e5d7a0a70f220565870ca671971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb03654ab03fe6c386047c38832c1120fdae8eecfd945e10e0515ca3a9765b29"
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

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
