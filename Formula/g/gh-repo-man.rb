class GhRepoMan < Formula
  desc "Manage GitHub repositories interactively from the terminal"
  homepage "https://github.com/2KAbhishek/gh-repo-man"
  url "https://github.com/2KAbhishek/gh-repo-man/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "beb52c99fb100344c81bd0ee7272b1f92e71458e4dbd1cc7e90c3f77843bbab3"
  license "MIT"
  head "https://github.com/2KAbhishek/gh-repo-man.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aabb592596ab7807de05052a430af2cabd9cd70aa17028b36b44f8b6197dd3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9aabb592596ab7807de05052a430af2cabd9cd70aa17028b36b44f8b6197dd3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9aabb592596ab7807de05052a430af2cabd9cd70aa17028b36b44f8b6197dd3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15ca565da4a192380b5b779cdd0c3a7a76dd73816590d589307a7dd26cb0b366"
    sha256 cellar: :any,                 x86_64_linux:  "f41ad972282f3465dcef7fd82dc1e6b7aaee53ef838c1af4bb90ab5d24f04988"
  end

  depends_on "go" => :build
  depends_on "fzf"
  depends_on "gh"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."
  end

  test do
    testbin = testpath/"test-bin"
    testbin.mkpath

    gh = testbin/"gh"
    gh.write <<~SH
      #!/bin/sh
      if [ "$1" = "repo" ] && [ "$2" = "list" ]; then
        cat <<'JSON'
      [{"name":"sample-repo","description":"Sample repository","url":"https://github.com/brewtest/sample-repo","stargazerCount":3,"forkCount":1,"watchers":{"totalCount":2},"issues":{"totalCount":0},"owner":{"login":"brewtest"},"createdAt":"2025-01-01T00:00:00Z","updatedAt":"2025-01-02T00:00:00Z","diskUsage":42,"homepageUrl":"","isFork":false,"isArchived":false,"isPrivate":false,"isTemplate":false,"repositoryTopics":[],"primaryLanguage":{"name":"Go"}}]
      JSON
        exit 0
      fi
      if [ "$1" = "api" ] && [ "$2" = "user" ]; then
        echo '{"login":"brewtest"}'
        exit 0
      fi
      echo "unexpected gh invocation: $*" >&2
      exit 1
    SH

    fzf = testbin/"fzf"
    fzf.write <<~SH
      #!/bin/sh
      IFS= read -r first_line
      printf '%s\n' "$first_line"
    SH

    git = testbin/"git"
    git.write <<~SH
      #!/bin/sh
      if [ "$1" = "clone" ]; then
        mkdir -p "$3/.git"
        exit 0
      fi
      echo "unexpected git invocation: $*" >&2
      exit 1
    SH

    chmod 0755, [gh, fzf, git]
    ENV.prepend_path "PATH", testbin

    home = Pathname(Dir.home)
    config_dir = home/".config"/"gh-repo-man"
    config_dir.mkpath
    config = config_dir/"config.yml"
    config.write <<~YAML
      repos:
        projects_dir: #{home/"projects"}
        per_user_dir: false
      integrations:
        post_clone:
          enabled: false
    YAML

    output = shell_output("#{bin}/gh-repo-man --user brewtest")
    assert_match "Successfully cloned sample-repo", output
    assert_path_exists home/"projects"/"sample-repo"/".git"
  end
end
