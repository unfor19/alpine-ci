# alpine-ci

[![Push latest release to DockerHub](https://github.com/unfor19/alpine-ci/workflows/Push%20latest%20release%20to%20DockerHub/badge.svg)](https://github.com/unfor19/alpine-ci/actions?query=workflow%3A%22Push+latest+release+to+DockerHub%22)

Docker image of Linux alpine which includes the following packages

<!-- replacer_start -->

```
alpine   3.12
bash     5.0
curl     7.69
git      2.26
jq       1.6
openssh  8.3
zip      3.0
```

<!-- replacer_end -->

## Included in alpine

- less
- tar
- wget

## Tips

### When to use **ubuntu** instead of alpine?

Choosing alpine is awesome, but in some scenarios it just won't cut it. Here are some popular use-cases that might help you with choosing the right linux distribution.

- Building a Python app - some Python packages require [glibc](https://www.gnu.org/software/libc/) and trying to compile them with alpine's [musl](https://www.musl-libc.org/) won't do it. For simple Python apps it's ok, but if it breaks after you add some package, then switching to `ubuntu` might be better for you
- [AWS CLI v1](https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html#install-linux-prereqs) - requires Python
- [AWS CLI v2](https://github.com/aws/aws-cli/issues/4971) - requires `glibc`

## Authors

Created and maintained by [Meir Gabay](https://github.com/unfor19)