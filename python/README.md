# Python

## Links

## Notes

## Package Manager
`pip`
- `install pkg==1.0`
- `install --upgrade pkg==1.1`

Proper way when dealing with mulitple `python` versions is to use `python` to call `pip`:

```
$ python -m pip install pkg==1.0
```

Replace `python` with whichever version of Python you need as each library gets installed to its own unique place.
