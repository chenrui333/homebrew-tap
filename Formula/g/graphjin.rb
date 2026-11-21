class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.23.tar.gz"
  sha256 "52ece63ecb0dfbdd113479e01b1a42f8dfb510545ee757544f764c1ecbb547d8"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "b65dbfe6dbb8fec8155fc66e3ccf7635b997eeb9f5b329ce6b653c511b29e4c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8802f129ade37d4fff29d98c6a757bdc89299ac97641d0f61abea6f0081749f5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db07ef8e8d362d8553ba0528ac63beff99a569afca06f5c27242b867f2651f77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "612343e6f807fae1111a60f41be7a01ea377ad1a9af472e8478cc3016892fbd5"
    sha256 cellar: :any,                 x86_64_linux:  "a57c338e4271a9b58ff6c6deef45859576d08d6853fc1a7dcaac76bdc25ee0b6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "cmd" do
      system "go", "mod", "download"
    end
  end

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
